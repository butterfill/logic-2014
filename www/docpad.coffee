# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

#http://docpad.org/docs/troubleshoot#watching-doesn-t-work-works-only-some-of-the-time-or-i-get-eisdir-errors
watchOptions: preferredMethods: ['watchFile','watch']

plugins:
  #this avoids problems with svg which require text elements!
  text:
    matchElementRegexString: 't'
  raw:
    raw:
      # rsync
      # -r recursive
      # -u skip file if the destination file is newer
      # -l copy any links over as well
      command: ['rsync', '-rul', './src/raw/', './out/' ]


	#renderPasses : 1

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://logic-2014.butterfill.com"

			# The default title of our website
			title: "Logic I"

			# The website description (for SEO)
			description: """
        Notes for lectures on Logic I (PH126 and PH133), an introduction to predicate logic.
        				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				logic, truth, logical validity
				"""


		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')
      

	collections:
		lectures: -> @getCollection('documents').findAll({basename:/^(fast)?lecture_/}, [basename:1])
		normal_lectures: -> @getCollection('documents').findAll({basename:/^lecture_/}, [basename:1])
		short_lectures: -> @getCollection('documents').findAll({basename:/^short_lecture_/}, [basename:1])
		fast_lectures: -> @getCollection('documents').findAll({basename:$startsWith:'fastlecture_'}, [basename:1])
		units: -> @getCollection('documents').findAll({url:/\/units\/unit_/}, [sequence:1])
      
			
}

# Export our DocPad Configuration
module.exports = docpadConfig