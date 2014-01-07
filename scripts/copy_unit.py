# copies units from 2012-3 to 2013-4, updating as they're copied



import os, sys
import getopt
import re

BASE_PATH_SRC = "/Users/stephenbutterfill/Documents/lectures/logic 2012-3 ph126 and ph133/src/"
BASE_PATH_DEST = "/Users/stephenbutterfill/Documents/lectures/logic 2013-4 ph126 and ph133/www/src/"
IMG_DIR_SRC = BASE_PATH_SRC + 'files/img/'
IMG_DIR_DEST = BASE_PATH_DEST + 'raw/img/'
DOC_DIR_SRC = BASE_PATH_SRC + 'documents/units/'
DOC_DIR_DEST = BASE_PATH_DEST + 'documents/units/'

def get_img_lines(the_path):
  """for each file in folder referenced by full path the_path, say unit_06, say slide-038.jpeg, creates this:
    +slide({bkg:'unit_06/slide-038.jpeg'})
    .notes 
  """
  file_names = os.popen('ls "%s"' % the_path).read().strip().split()
  file_names = [fn for fn in file_names if re.search('.jpeg$', fn) is not None ] 
  template = "+slide({bkg:'"+folder_name+"/%s'})\n  .notes \n\n"
  lines = [template % fn for fn in file_names]
  return ''.join(lines)

def do_move(param):
  #first, create the new unit.html.jade file
  filename = 'unit_'+param+'.html.jade'
  img_folder_name = 'unit_'+param
  img_folder_path_src = IMG_DIR_SRC+img_folder_name
  source_filename = DOC_DIR_SRC + filename
  source_txt = open(source_filename).read()
  #update the layout
  dest_txt = source_txt.replace("layout: 'deck_slides_img'","layout: 'deck_units'")
  #add the unit_mixins
  dest_txt += "\n\ninclude ../../../fragments/unit_mixins\n\n"
  #add the slide lists
  img_lines = get_img_lines(img_folder_path_src)
  dest_txt += img_lines
  #write the file
  dest_filename = DOC_DIR_DEST + filename
  dest_file = open(dest_filename, 'w')
  dest_file.write(dest_txt)
  dest_file.close()
  #finally, copy the directory of images
  cmd_str = 'cp "%s" "%s"' % (img_folder_path_src, IMG_DIR_DEST)
  os.system(cmd_str)


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
            raise Usage("Exactly one argument is required, the name of the unit (e.g. 011).")
        param = args[0].strip()
        do_move(param)
        
    except Usage, err:
        print >>sys.stderr, err.msg
        print >>sys.stderr, "for help use --help"
        return 2

if __name__ == "__main__":
    sys.exit(main())
