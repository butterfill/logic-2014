# reads a directory of jpeg files
# creates a document for a deck.js / jade / docpad presentation of the directory
# ie. for each file in folder unit_06, say slide-038.jpeg, there is this:
#
# +slide({bkg:'unit_06/slide-038.jpeg'})
#  .notes 
#
# The document is copied to the clipboard.

import os, sys
import getopt
import re



#from http://coffeeghost.net/src/pyperclip.py
def macGetClipboard():
    outf = os.popen('pbpaste', 'r')
    content = outf.read()
    outf.close()
    return content

def macSetClipboard(text):
    outf = os.popen('pbcopy', 'w')
    outf.write(text)
    outf.close()




# following is just main() wrapper
#main() wrapper is by GvRget
class Usage(Exception):
    def __init__(self, msg):
        self.msg = msg

def main(argv=None):
    if argv is None:
        argv = sys.argv
    try:
        try:
            opts, args = getopt.getopt(argv[1:], "h", ["help"])
        except getopt.error, msg:
             raise Usage(msg)
        # process options
        for o, a in opts:
            if o in ("-h", "--help"):
                print __doc__
                sys.exit(0)
        # do it
        if len(args) < 1:
            raise Usage("Exactly one argument is required, the path to the directory containing the images.")
        the_path = args[0].strip()
        folder_name = the_path.split('/')[-1]
        file_names = os.popen('ls "%s"' % the_path).read().strip().split()
        file_names = [fn for fn in file_names if re.search('.png$', fn) is not None ] 
        template = "+slide({bkg:'"+folder_name+"/%s'})\n  .notes: :t \n\n"
        lines = [template % fn for fn in file_names]
        res = ''.join(lines)
        macSetClipboard(res)
        
    except Usage, err:
        print >>sys.stderr, err.msg
        print >>sys.stderr, "for help use --help"
        return 2

if __name__ == "__main__":
    sys.exit(main())
