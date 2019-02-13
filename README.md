# Cms

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/cms`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cms'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cms

## Extended markdown syntax

### You can add HTML attributes with curly brackets {: ... :}<br>

``` markdown
{: .class.next__class.another--class, #id, data: { content: 'test' }, style: 'display: inline-block;', target: '_blank', rel: 'nofollow',  aria: { labelledby: 'ch1Tab' } :}
```

- To link nodes at the end of node

  ``` markdown
  [name](https://www.test.com){: .class-name.another-name, #id, target: '_blank', rel: 'nofollow' :}
  ```

  **If target: '_blank' is used, rel="noopener noreferrer" will be attached to avoid tabnabbing attack**

- To paragraph nodes before the node

  ``` markdown
  {: .class-name.another-class-name, #id-name, data: {handler: 'toggle', content: 'hidden'} :}
  In the Bohr model, the transition of an electron with n=3 to the shell n=2 is shown, where a photon is emitted. An electron from shell (n=2) must have been removed beforehand by ionization
  Electrons that populate a shell are said to be in a bound state. The energy necessary to remove an electron from its shell (taking it to infinity) is called the binding energy.
  Any quantity of energy absorbed by the electron in excess of this amount is converted to kinetic energy according to the conservation of energy.
  The atom is said to have undergone the process of ionization.
  ```

- To header nodes before the node

  ``` markdown
  {: .class-name.another-class-name, #id-name, data: {handler: 'toggle', content: 'hidden'} :}
  ## Atomic physics
  ```

### Syntax examples

- Class attribute enums through points w/o spaces and don't framed by quotes

  ``` markdown
  {: .class-name.another-class-name :}
  ```

- ID attribute w/o spaces and don't framed by quotes

  ``` markdown
  {: #id-name :}
  ```

- Data or Aria attributes

  ``` markdown
  {: data: {handler: 'toggle', content: 'hidden'} :}
  {: data-handler: 'toggle', data-content: 'hidden' :}

  {: aria: { labelledby: 'ch1Tab' } :}
  {: aria-labelledby: 'ch1Tab' :}
  ```

- Style attributes **(keep naming convention for HTML attributes)**

  ``` markdown
  {: style: 'display: inline-block; width: 100px;' :}
  ```

- Other HTML attributes

  ``` markdown
  {: target: '_blank', rel: 'nofollow' :}
  ```

### Pay attention on the syntax!

- All keys should be terminated by colon and values should be framed by quotes

  ``` js
  {: keyname: 'value' :}
  ```

- All pairs of key: 'value' should be separated by comma

  ``` js
  {: data: {handler: 'toggle', content: 'hidden'}, style: 'display: inline-block;' :}
  ```

- Avoid redundant brackets in data: or aria: attributes

  Wrong syntax example:

  ```js
  {: data: {handler: 'toggle', {content: 'hidden'}, status: 'showed'} :}
  {: data: {handler: 'toggle', { content: 'hidden'} :}
  ```

## Layouts

You can create default layout by creating `default_layout` fragment.
I will be aplied to all `markdown` pages implicitly. It is recommended
do not use idention because of markdown.

### Layout example:

``` html
<div class="simple-layout">
<div class="inner">
<div class="content">
{content}
</div>
</div>
</div>
```

- It is possible to set layout explicitly:

  ``` markdown
  { layout = servivces }

  # Services

  * Mobile
  * Web
  ```

- Or if you don't want any layout

  ``` markdown
  { layout = false }
  ```

Also before applying  default layout the system will try to find layout
corresponding to specified url. For example for pages `/services`,
`/services/web-development`, `/services/backend/ruby` `services` layout
will be applied.

## Caching

Caching requires redis. You can configure caching to make actions
before and after perform. Or skip it altogether with condition

``` ruby
Rails.application.config.action_controller.perform_caching = true

Cms::ClearCache.configure do |config|
  config.around_perform = lambda do |options, &perform|
    if Rails.application.config.action_controller.perform_caching

      perform.call

      # Schedule cache warmup for published pages
      Page.with_published_state.map(&:url).each do |url|
        Cms::RestoreCacheWorker.perform_async(url)
      end

      # Stop phantomjs
      Cms::StopBrowserWorker.perform_async
    end
  end
end

```

To enable cache warmup run

``` sh
bundle exec sidekiq -c 1 -q restore_cache
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitLab at https://gitlab.anahoret.com/[USERNAME]/cms.
