class ApplicationService
  def self.call(method_name = :call, **kwargs, &block)
    new.send(method_name, **kwargs, &block)
  end
end