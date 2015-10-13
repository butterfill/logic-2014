# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON

docpadConfig = {

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
      url: "http://logic-1.butterfill.com"

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

    get_unit : (unit_num) ->
      extract = (unit_num+'').match(/^unit_([0-9]*)/)
      if extract
        unit_num = extract[1]
      d = @getCollection("documents").findAll({url:'/units/unit_'+unit_num+'.html'},[{year:-1,sort_order:1}]).toJSON()
      if d?[0]?
        if @document.units?.indexOf(unit_num) is -1
          @document.units.push(unit_num)
      else
        d = @getCollection("documents").findAll({url:'/units/'+unit_num+'.html'},[{year:-1,sort_order:1}]).toJSON()
      unit = d?[0]
      if not unit?
        console.log(' ')
        console.log('*** missing unit: '+unit_num)
      return unit
    
    getNormalEx : () ->
      result = 
        'courseName' : 'UK_W20_PH126'
        'variant' : 'normal'
        'description' : 'These exercises are aimed at students who did not take a mathematical subject at A-Level or equivalent.'
        'lectures' : @_getLectures(@getCollection("normal_lectures").toJSON(), 'exNormal')
      return result
    getFastEx : () ->
      result = 
        'courseName' : 'UK_W20_PH126'
        'variant' : 'fast'
        'description' : 'These exercises are aimed at students with a qualification equivalent to further maths at A-Level.'
        'lectures' : @_getLectures(@getCollection("fast_lectures").toJSON(), 'exFast')
      return result
    getShortNormalEx : () ->
      result = 
        'courseName' : 'UK_W20_PH133'
        'variant' : 'short'
        'description' : 'These exercises are aimed at students taking the logic part of PH133 (Introduction to Philosophy).'
        'lectures' : @_getLectures(@getCollection("short_lectures").toJSON(), 'exNormal')
      return result
    getShortFastEx : () ->
      result = 
        'courseName' : 'UK_W20_PH133'
        'variant' : 'short'
        'description' : 'These exercises are aimed at students with a qualification equivalent to further maths at A-Level taking the logic part of PH133 (Introduction to Philosophy).'
        'lectures' : @_getLectures(@getCollection("short_lectures").toJSON(), 'exFast')
      return result

    # Go through the collection specified by `lectures` and create the object that
    # will be a document in the `ExerciseSets` collection of `love*logic`.
    _getLectures : (lectures, exType) ->
      baseurl = 'http://logic-1.butterfill.com'
      result = []
      for lecture in lectures
        lectureDoc = {
          'type' : 'lecture'
          'name' : lecture.basename
          'slides' : "#{baseurl}#{lecture.url}"
          'handout' : "#{baseurl}/handouts/#{lecture.basename}.handout.pdf"
          'units' : []
        }
        for unitNum in lecture.units
          unit = @get_unit(unitNum)
          if unit?[exType]?
            lectureDoc.units.push {
              'type' : 'unit'
              'name' : unit.title
              'slides' : "#{baseurl}#{unit.url}"
              'rawReading' : unit.book or []
              'rawExercises' : unit[exType]
            }
        result.push(lectureDoc)
      return result

  collections:
    lectures: -> @getCollection('documents').findAll({basename:/^(fast)?lecture_/}, [basename:1])
    normal_lectures: -> @getCollection('documents').findAll({basename:/^lecture_/}, [basename:1])
    short_lectures: -> @getCollection('documents').findAll({basename:/^short_lecture_/}, [basename:1])
    fast_lectures: -> @getCollection('documents').findAll({basename:$startsWith:'fastlecture_'}, [basename:1])
    units: -> @getCollection('documents').findAll({url:/\/units\/unit_/}, [sequence:1])
      
      
}

# Export our DocPad Configuration
module.exports = docpadConfig
