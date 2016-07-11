require 'linguist'

module Cms
  module Filters
    class SyntaxHighlight < ::HTML::Pipeline::Filter
      def call
        doc.search('pre').each do |pre|
          code = pre.inner_text

          if language_name = language_name_from_node(pre)
            language = lookup_language(language_name)
          elsif detect_language?
            detected = detect_languages(code).first
            language = detected && lookup_language(detected[0])
          end

          if html = language && lexer(language).highlight(code)
            pre.replace(html)
          end
        end
        doc
      end

      def detect_language?
        context[:detect_syntax] != false
      end

      def language_name_from_node(node)
        # Commonmark set language to code element class like 'language-scala'
        if class_name = node.children.first['class']
          class_name[/language-(.+)/, 1]
        end
      end

      def lookup_language(name)
        Linguist::Language[name]
      end

      def detect_languages(code)
        Linguist::Classifier.classify(classifier_db, code, possible_languages)
      end

      def classifier_db
        Linguist::Samples.cache
      end

      def possible_languages
        popular_language_names & sampled_languages
      end

      def popular_language_names
        Linguist::Language.popular.map {|lang| lang.name }
      end

      def sampled_languages
        classifier_db['languages'].keys
      end

      def lexer(language)
        language.aliases.map do |l|
          Pygments::Lexer.find_by_name(l.humanize) ||
          Pygments::Lexer.find_by_name(l.upcase) ||
          Pygments::Lexer.find_by_alias(l.humanize.downcase)
        end
        .compact
        .first ||
        Pygments::Lexer.find_by_name('Text only')
      end
    end
  end
end
