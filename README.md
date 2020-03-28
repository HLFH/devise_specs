# devise_specs
[![Build Status](https://travis-ci.org/HLFH/devise_specs.svg?branch=master)](https://travis-ci.org/HLFH/devise_specs)
[![Maintainability](https://api.codeclimate.com/v1/badges/711148d0ea721811f6f9/maintainability)](https://codeclimate.com/github/HLFH/devise_specs/maintainability)

Drop-in upgrade of legacy `devise-specs` gem.

`devise_specs` is a Rails generator that adds the Devise authentication acceptance tests when you run the `devise` generator. The tests are RSpec feature specs containing Factory Bot or Fabrication fixture replacement methods and Capybara actions.

Generated feature specs test the following features:
* Registration
* Login
* Logout
* Password reset

Works with Rails 6+.

## Installation

Make sure `devise_specs`, `devise`, `rspec-rails`, `capybara` and fixture replacement gems are added to the `Gemfile`:
```ruby
gem 'devise'

group :development do
  gem 'devise_specs'
end

group :test do
  gem 'capybara'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails' # or: gem 'fabrication'
end
```

and then run `bundle install`.

## Setup

Generate the RSpec configuratoin files:
```
$ bundle exec rails generate rspec:install
```

Generate the Devise configuration files and follow the setup instructions to define the default url options, root route and flash messages:
```
$ bundle exec rails generate devise:install
```

Configure the Action Mailer URL options for the test environment using the following line in `config/environments/test.rb`:
```ruby
config.action_mailer.default_url_options = { host: 'localhost', port: 3001 }
```

Add the authentication links to the layout in `app/views/layouts/application.html.erb`, `user_signed_in?` should be `admin_signed_in?` if your Devise model is `Admin`:
```erb
    <%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <p class='notice'><%= notice %></p>
    <p class='alert'><%= alert %></p>
    <ul class="hmenu">
      <%= render 'devise/menu/account_items' %>
    </ul>
    <%= yield %>
  </body>
  
```

In `app/views/devise/menu/_account_items.html.erb`, please add:
```ruby
<% if user_signed_in? %>
  <li>
  <%= link_to('Edit registration', edit_user_registration_path) %>
  </li>
  <li>
  <%= link_to('Sign out', destroy_user_session_path, method: :delete) %>        
  </li>
<% else %>
  <li>
    <%- if controller_name != 'sessions' %>
      <%= link_to 'Sign in', new_session_path(resource_name) %>
    <% end %>
  </li>
  <li>
    <%- if devise_mapping.registerable? && controller_name != 'registrations' %>
      <%= link_to 'Create an account', new_registration_path(resource_name) %><br />
    <% end %>
  </li>
<% end %>

```

In `app/views/devise/shared/_links.html.erb`, verify you only have the following: 
```ruby
<%- if devise_mapping.recoverable? && controller_name != 'passwords' && controller_name != 'registrations' %>
  <%= link_to 'Forgot your password?', new_password_path(resource_name) %><br />
<% end %>

<%- if devise_mapping.confirmable? && controller_name != 'confirmations' %>
  <%= link_to "Didn't receive confirmation instructions?", new_confirmation_path(resource_name) %><br />
<% end %>

<%- if devise_mapping.lockable? && resource_class.unlock_strategy_enabled?(:email) && controller_name != 'unlocks' %>
  <%= link_to "Didn't receive unlock instructions?", new_unlock_path(resource_name) %><br />
<% end %>

<%- if devise_mapping.omniauthable? %>
  <%- resource_class.omniauth_providers.each do |provider| %>
    <%= link_to "Sign in with #{OmniAuth::Utils.camelize(provider)}", omniauth_authorize_path(resource_name, provider) %><br />
  <% end %>
<% end %>

```

In `app/views/devise/sessions/new.html.erb`, add:
```ruby
<h2>Sign in</h2>

<%= form_for(resource, as: resource_name, url: session_path(resource_name)) do |f| %>
  <div class="field">
    <%= f.label :email %><br />
    <%= f.email_field :email, autofocus: true, autocomplete: 'email' %>
  </div>

  <div class="field">
    <%= f.label :password %><br />
    <%= f.password_field :password, autocomplete: 'current-password' %>
  </div>

  <% if devise_mapping.rememberable? %>
    <div class="field">
      <%= f.check_box :remember_me %>
      <%= f.label :remember_me %>
    </div>
  <% end %>

  <div class="actions">
    <%= f.submit 'Sign in' %>
  </div>
<% end %>

<%= render 'devise/shared/links' %>

```

In `app/views/devise/registrations/new.html.erb`, add:
```ruby
<h2>Create your Account</h2>

<%= form_for(resource, as: resource_name, url: registration_path(resource_name)) do |f| %>
  <%= render 'devise/shared/error_messages', resource: resource %>

  <div class="field">
    <%= f.label :email %><br />
    <%= f.email_field :email, autofocus: true, autocomplete: 'email' %>
  </div>

  <div class="field">
    <%= f.label :password %>
    <% if @minimum_password_length %>
    <em>(<%= @minimum_password_length %> characters minimum)</em>
    <% end %><br />
    <%= f.password_field :password, autocomplete: 'new-password' %>
  </div>

  <div class="field">
    <%= f.label :password_confirmation %><br />
    <%= f.password_field :password_confirmation, autocomplete: 'new-password' %>
  </div>

  <div class="actions">
    <%= f.submit 'Create Account' %>
  </div>
<% end %>

<%= render 'devise/shared/links' %>

```

Don't forget to add a bit of style for Webpacker in `app/javascript/src/application.scss`:
```scss
ul.hmenu {
  list-style: none;
  margin: 0 0 2em;
  padding: 0;

  li {
    display: inline;
  }
}
```

And add in `app/javascript/packs/application.js`:
```js
import '../src/application.scss'
```

## Usage

Specs are created automatically when you generate a Devise model, e.g. `User`:
```
$ bundle exec rails generate devise User
         ...
      invoke  specs
        gsub    spec/rails_helper.rb
      insert    spec/factories/users.rb
      create    spec/support/factory_bot.rb
      create    spec/support/devise.rb
      create    spec/features/user_signs_up_spec.rb
      create    spec/features/user_signs_in_spec.rb
      create    spec/features/user_signs_out_spec.rb
      create    spec/features/user_resets_password_spec.rb
```

If a Devise model is already present, run the `devise:specs` generator directly:
```
$ bundle exec rails generate devise:specs User
```

Run the migrations:
```
$ rake db:migrate RAILS_ENV=test
```

Make sure the specs pass:
```
$ rspec spec/features
.........

Finished in 0.93371 seconds (files took 1.88 seconds to load)
9 examples, 0 failures

```

## Documentation

Visit the [Relish docs](https://relishapp.com/andrii/devise_specs/docs) for all the available features and legacy examples of the generated feature specs.

## Output

`gsub    spec/rails_helper.rb`

Uncomments the line that auto-requires all files in the support directory.

`insert    spec/fabricators/*_fabricator.rb`

Adds `email` and `password` attributes to the fabricator.

`insert    spec/factories/*.rb`

Adds `email` and `password` attributes to the factory.

`create    spec/support/factory_bot.rb`

Includes `FactoryBot::Syntax::Methods` into RSpec config to avoid prefacing Factory Bot methods with `FactoryBot`.

`create    spec/support/devise.rb`

Includes Devise integration test helpers into feature specs.

`create    spec/features/*_spec.rb`

Generates a corresponding feature spec.

## Testing

Install Ruby, development tools, Nokogiri, SQLite and JavaScript runtime system dependencies.

On Ubuntu/Mint/Debian:
```
$ apt-get install ruby-full build-essential zlib1g-dev libsqlite3-dev nodejs
```

Install development dependencies with `bundle install` and run the tests: 
```
$ bundle exec rake
```

## License

MIT License
