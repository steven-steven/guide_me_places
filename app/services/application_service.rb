class ApplicationService
  def self.call(method_name = :call, **kwargs, &block)
    new(**kwargs, &block).send(method_name)
  end
end