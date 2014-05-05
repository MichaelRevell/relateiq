# RelateIQ API Ruby Client

A ruby-based http client for the RelateIQ API

For the latest information on the API, look at:

* [RelateIQ's API Documentation](http://api.relateiq.com/)

##Usage Examples##

###Including the gem in your Gemfile###

    gem 'relateiq'


###Initializing the client###
Your api_key / api_secret is required to initialize the client.  Refer to the ["Requesting Access"](http://api.relateiq.com/#/curl#documentation_introduction-and-basics_requesting-access) section of RelateIQ's API documentation on how to set these.


    RelateIQ.configure :api_key => YOUR_API_KEY,
                        :api_secret => YOUR_API_SECRET,
                        :base_url => "https://api.relateiq.com/v2"

###API methods###

Responses are returned as hashes.

Errors returned by the API will be raised as exceptions.

**Examples:**

You can make requests by invoking the lower level api methods `get`, `post`, and `put` on objects.  See [RelateIQ's API documentation](https://api.relateiq.com/#/curl#documentation_objects-of-the-system) for more information about the list of available resources/objects.  Methods are called by simply passing in the URI of the resource you are accessing, along with any needed data as a hash object.

Create a contact:

    contact = {
      :name=> [{:value=> "John Doe"}],
      :email=> [{:value=> "jd@example.com"}],
      :phone=> [{:value=> "555-555-5555"}],
      :address=> [{:value=> "123 Main St., San Francisco, CA 94103"}],
      :company=> [{:value=> "ABC Company"}],
      :title=> [{:value=> "CEO"}]
    }

    response = RelateIQ.post('/contacts', { :properties => contact })

Get a list of contacts:

    response = RelateIQ.get('/contacts')