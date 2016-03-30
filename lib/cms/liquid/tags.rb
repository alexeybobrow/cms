module Cms
  module Liquid
    module Tags
      autoload :Base, 'cms/liquid/tags/base'
      autoload :BaseBlock, 'cms/liquid/tags/base_block'
      autoload :Author, 'cms/liquid/tags/author'
      autoload :Fragment, 'cms/liquid/tags/fragment'
      autoload :LinkTo, 'cms/liquid/tags/link_to'
      autoload :Snippet, 'cms/liquid/tags/snippet'

      autoload :AttributesUtils, 'cms/liquid/tags/attributes_utils'
      autoload :HamlUtils, 'cms/liquid/tags/haml_utils'
    end
  end
end
