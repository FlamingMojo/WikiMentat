# For adding some wicked metaprogramming on all Objects
class Object
  # Send a whole chain of methods, including arguments
  def send_chain(arr)
    Array(arr).inject(self) { |o, a| o.send(*a) }
  end
end
