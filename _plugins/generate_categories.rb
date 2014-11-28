# encoding: utf-8
#
# Jekyll category page generator.
# http://recursive-design.com/projects/jekyll-plugins/
#
# Version: 0.2.4 (201210160037)
#
# Copyright (c) 2010 Dave Perrett, http://recursive-design.com/
# Licensed under the MIT license (http://www.opensource.org/licenses/mit-license.php)
#
# A generator that creates category pages for jekyll sites.
#
# To use it, simply drop this script into the _plugins directory of your Jekyll site. You should
# also create a file called 'category_index.html' in the _layouts directory of your jekyll site
# with the following contents (note: you should remove the leading '# ' characters):
#
# ================================== COPY BELOW THIS LINE ==================================
# ---
# layout: default
# ---
#
# <h1 class="category">{{ page.title }}</h1>
# <ul class="posts">
# {% for post in site.categories[page.category] %}
#     <div>{{ post.date | date_to_html_string }}</div>
#     <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
#     <div class="categories">Filed under {{ post.categories | category_links }}</div>
# {% endfor %}
# </ul>
# ================================== COPY ABOVE THIS LINE ==================================
#
# You can alter the _layout_ setting if you wish to use an alternate layout, and obviously you
# can change the HTML above as you see fit.
#
# When you compile your jekyll site, this plugin will loop through the list of categories in your
# site, and use the layout above to generate a page for each one with a list of links to the
# individual posts.
#
# You can also (optionally) generate an atom.xml feed for each category. To do this, copy
# the category_feed.xml file to the _includes/custom directory of your own project
# (https://github.com/recurser/jekyll-plugins/blob/master/_includes/custom/category_feed.xml).
# You'll also need to copy the octopress_filters.rb file into the _plugins directory of your
# project as the category_feed.xml requires a couple of extra filters
# (https://github.com/recurser/jekyll-plugins/blob/master/_plugins/octopress_filters.rb).
#
# Included filters :
# - category_links:      Outputs the list of categories as comma-separated <a> links.
# - date_to_html_string: Outputs the post.date as formatted html, with hooks for CSS styling.
#
# Available _config.yml settings :
# - category_dir:          The subfolder to build category pages in (default is 'categories').
# - category_title_prefix: The string used before the category name in the page title (default is
#                          'Category: ').

require "jekyll-paginate/pager"

module Jekyll

  # The CategoryIndex class creates a single category page for the specified category.
  class CategoryPage < Page

    # Initializes a new CategoryIndex.
    #
    #  +template_path+ is the path to the layout template to use.
    #  +site+          is the Jekyll Site instance.
    #  +base+          is the String path to the <source>.
    #  +category_dir+	 is the category folder that does not includes the potential pagination directory.
    #  +page_dir+  		 is the String path between <source> and the page name.
    #  +category+      is the category currently being processed.
    def initialize(template_path, name, site, base, category_dir, category, lang, page_dir=nil)
      @site  = site
      @base  = base
      @dir   = page_dir || category_dir
      @name  = name

      self.process(name)

			if category == lang
				@perform_render = false
      elsif File.exist?(template_path)
        @perform_render = true
        template_dir    = File.dirname(template_path)
        template        = File.basename(template_path)
        # Read the YAML data from the layout page.
        self.read_yaml(template_dir, template)
        self.data['category']    = category
        self.data['category_dir']= File.join(site.baseurl, category_dir)
        # Set the title for this page.
        title_prefix             = site.config['category_title_prefix'] || 'Category: '
        self.data['title']       = "#{title_prefix}#{category}"
				self.data['lang']				 = lang
        # Set the meta-description for this page.
        meta_description_prefix  = site.config['category_meta_description_prefix'] || 'Category: '
        self.data['description'] = "#{meta_description_prefix}#{category}"
      else
        @perform_render = false
      end
    end

    def render?
      @perform_render
    end

  end

  # The CategoryIndex class creates a single category page for the specified category.
  class CategoryIndex < CategoryPage

    # Initializes a new CategoryIndex.
    #
    #  +site+         is the Jekyll Site instance.
    #  +base+         is the String path to the <source>.
    #  +category_dir+	is the category folder that does not includes the potential pagination directory.
    #  +page_dir+  		is the String path between <source> and the page name.
    #  +category+     is the category currently being processed.
    def initialize(site, base, page_dir, category, lang, category_dir=nil)
      template_path = File.join(base, '_layouts', 'category_index.html')
      super(template_path, '', site, base, page_dir, category, lang, category_dir)
    end

  end

  # The CategoryFeed class creates an Atom feed for the specified category.
  class CategoryFeed < CategoryPage

    # Initializes a new CategoryFeed.
    #
    #  +site+         is the Jekyll Site instance.
    #  +base+         is the String path to the <source>.
    #  +category_dir+ is the String path between <source> and the category folder.
    #  +category+     is the category currently being processed.
    def initialize(site, base, category_dir, category, lang)
      template_path = File.join(base, '_includes', 'custom', 'category_feed.xml')
      super(template_path, 'feed.xml', site, base, category_dir, category, lang)

      # Set the correct feed URL.
      self.data['feed_url'] = "#{name}" if render?
    end

  end
  
  # The CategoryJson class creates an JSON for the specified category.
  class CategoryJson < CategoryPage

    # Initializes a new CategoryJson.
    #
    #  +site+         is the Jekyll Site instance.
    #  +base+         is the String path to the <source>.
    #  +category_dir+ is the String path between <source> and the category folder.
    #  +category+     is the category currently being processed.
    def initialize(site, base, category_dir, category, lang)
      template_path = File.join(base, '_includes', 'custom', 'category_json.json')
      super(template_path, 'latest.json', site, base, category_dir, category, lang)

      # Set the correct feed URL.
      self.data['feed_url'] = "#{name}" if render?
    end

  end

  # The Site class is a built-in Jekyll class with access to global site config information.
  class Site

    # Creates an instance of CategoryIndex for each category page, renders it, and
    # writes the output to a file.
    #
    #  +category+ is the category currently being processed.
    def write_category_index(category)
			for lang in Jekyll.configuration({})['languages']
				target_dir = GenerateCategories.category_dir(lang, category)
				if not self.config['paginate_categories']
					index = CategoryIndex.new(self, self.source, target_dir, category, lang)
					if index.render?
						index.render(self.layouts, site_payload)
						index.write(self.dest)
						# Record the fact that this pages has been added, otherwise Site::cleanup will remove it.
						self.pages << index
					end
				else
					all_posts = self.categories[category]
					pages = Paginate::Pager.calculate_pages(all_posts, self.config['paginate'].to_i)
					(1..pages).each do |num_page|
						if num_page == 1
							category_path = target_dir
						else
							category_path = File.join(target_dir, Paginate::Pager.paginate_path(self, num_page))
						end

						index = CategoryIndex.new(self, self.source, target_dir, category, lang, category_path)
						index.pager = Paginate::Pager.new(self, num_page, all_posts, pages)

						if index.render?
							index.render(self.layouts, site_payload)
							index.write(self.dest)
							# Record the fact that this pages has been added, otherwise Site::cleanup will remove it.
							self.pages << index
						end
					end
				end

				# Create an Atom-feed for each index.
				feed = CategoryFeed.new(self, self.source, target_dir, category, lang)
				if feed.render?
					feed.render(self.layouts, site_payload)
					feed.write(self.dest)
					# Record the fact that this pages has been added, otherwise Site::cleanup will remove it.
					self.pages << feed
				end

				# Create a JSON-feed for each index.
				json = CategoryJson.new(self, self.source, target_dir, category, lang)
				if json.render?
					json.render(self.layouts, site_payload)
					json.write(self.dest)
					# Record the fact that this pages has been added, otherwise Site::cleanup will remove it.
					self.pages << json
				end
			end
    end

    # Loops through the list of category pages and processes each one.
    def write_category_indexes
      if self.layouts.key? 'category_index'
        self.categories.keys.each do |category|
          self.write_category_index(category)
        end

      # Throw an exception if the layout couldn't be found.
      else
        throw "No 'category_index' layout found."
      end
    end

  end


  # Jekyll hook - the generate method is called by jekyll, and generates all of the category pages.
  class GenerateCategories < Generator
    safe true
    priority :low

    CATEGORY_DIR = 'categories'

    def generate(site)
      site.write_category_indexes
    end

    # Processes the given dir and removes leading and trailing slashes. Falls
    # back on the default if no dir is provided.
    def self.category_dir(base_dir, category)
      base_dir = (base_dir || CATEGORY_DIR).gsub(/^\/*(.*)\/*$/, '\1')
      category = category.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').downcase
      File.join(base_dir, category)
    end

  end


  # Adds some extra filters used during the category creation process.
  module Filters

    # Outputs a list of categories as comma-separated <a> links. This is used
    # to output the category list for each post on a category page.
    #
    #  +categories+ is the list of categories to format.
    #
    # Returns string
    def category_links(categories, lang)
      base_dir = @context.registers[:site].config['category_dir']
      categories = categories.sort!.map do |category|
        category_dir = GenerateCategories.category_dir(base_dir, category)
        # Make sure the category directory begins with a slash.
        category_dir = "/#{lang}" unless category_dir =~ /^\//
        "<a class='category' href='#{category_dir}/'>#{category}</a>"
      end

      case categories.length
      when 0
        ""
      when 1
        categories[0].to_s
      else
        categories.join(', ')
      end
    end

    # Outputs the post.date as formatted html, with hooks for CSS styling.
    #
    #  +date+ is the date object to format as HTML.
    #
    # Returns string
    def date_to_html_string(date)
      result = '<span class="month">' + date.strftime('%b').upcase + '</span> '
      result += date.strftime('<span class="day">%d</span> ')
      result += date.strftime('<span class="year">%Y</span> ')
      result
    end

  end

end
