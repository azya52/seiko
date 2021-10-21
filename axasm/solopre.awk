#/**********************************************************************
#axasm Copyright 2006, 2007, 2008, 2009 
#by Al Williams (alw@al-williams.com).
#
#
#This file is part of axasm.
#
#axasm is free software: you can redistribute it and/or modify it
#under the terms of the GNU General Public Licenses as published
#by the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#axasm is distributed in the hope that it will be useful, but
#WITHOUT ANY WARRANTY: without even the implied warranty of 
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with axasm (see LICENSE.TXT). 
#If not, see http://www.gnu.org/licenses/.
#
#If a non-GPL license is desired, contact the author.
#
#This is the assembler preprocessor
#
#***********************************************************************/
# expect -v LFILE=xxx argument (output of label definitions)
# allow -v PROC=xxx  (processor type)

# Note there are a few things the target macros must support
# LABEL, DEFLABEL - Supports the label system
#  DATA, DATA4  - Supports STRING and STRINGPACK
# Granted STRING and STRINGPACK ought to be removable somehow

BEGIN {
    if (LFILE!="") {
        if (PROC=="") {
            print "#include <soloasm.inc>";  # default inc file
        } else {
            print "#include <" PROC ".inc>";
        }
        print "#include \"lfile\""
        print "" > LFILE
    }
}

END {
    print "END;"
}


# one time init
{
    if (first != 1) { first=1;   print "#line 1 \"" FILENAME "\""; }
}


# pass through any line directives
/^#line / { print; next; }


# pass through C code and C preprocessor
/^[ \t]*##/  {sub("^[ \t]*##","#");  print; next; }
/^[ \t]*#/  { sub("^[ \t]*#",""); print; next; }


{
# This won't disturb semicolons if there is a quote
# directly after it. This could lead to trouble with
# semicolons in quoted strings, for example
# so we save just in case and string handling gets all of it

    withsemi=$0
    sub(";.*$","");  # remove asm comments
    op=1;
}

# deal with labels
/^[ \t]*[^ \t,]+:/ { 
    label=$1;
    sub(/:$/,"",label);
    print "DEFLABEL("  label  ");" >>LFILE;
    printf "LABEL("  label  "); ";
    $1="";
    op=2;
}

# blank lines (maybe it used to have just a label)
/^[ \t]*$/ { print; next; } 

{

    {
        if (start != 1) {
            start = 1;
            print "START;"
        }
    }

    print("LINE("  NR-1  ");");

    # note: the below means your .h file that defines the processor
    # must use uppercase names in macros but you are free to
    # use mixed case in the assembly
    # probably should make this an option somehow
    mac=toupper($op);
    $op="";
    # unpacked string
    if (mac=="DS") {
        $op="";
        strng=withsemi;
        qopen=0;

        # scan each letter. Note first quote, copy until 2nd quote
        for (i=1;i<length(strng);i++) {
            v=substr(strng,i,1); 
            if (v == "\"" && substr(strng,i-1,1) != "\\") {
                qopen = !qopen;
                continue;
            }
            if (!qopen) {
                if (v == ";") {
                    break;
                } else {
                    continue;
                }
            }           
            # if (v=="\\") { v=substr(strng,i,2); i++; }
            # handle \xNN \DDD or \C
            if (v=="\\") {
                v1=substr(strng,i+1,1);
                if (v1=="x"||v1=="X") {
                    v="\\x"
                    i+=2;
                    v=v substr(strng,i,1)
                    v1=substr(strng,i+1,1)
                    if ((v1>="0"&&v1<="9")||(tolower(v1)>="a"&&tolower(v1)<="f")) {
                        v=v v1
                        i++
                    }
                }
                else if (v1>="0" && v1<="7") { 
                    while (v1>="0" && v1<="7") {
                        v=v v1;
                        i++;
                        v1=substr(strng,i+1,1);
                    }
                } else {
                    v=substr(strng,i,2); 
                    i++;
                }
            }
            print "DATA('" v "');"
        }
        next;
    }
    # just some generic monadic macro or one with arguments
    if ($(op+1)=="") print(mac ";"); else print(mac  "("  $0  ");");
}