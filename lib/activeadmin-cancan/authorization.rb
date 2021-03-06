require 'activeadmin'
require 'cancan'
 
ActiveAdmin::Namespace.class_eval do
  alias_method :old_register, :register
  
  def register(resource_class, options = {}, &block)
    config = find_or_build_resource(resource_class, options)
    register_resource_controller(config)
    resource_dsl.prepare_menu(config)
    config = old_register(resource_class, options, &block)
    config.controller.load_and_authorize_resource
    config    
  end
end

ActiveAdmin::DSL.class_eval do
  def prepare_menu(config)
    @config = config
    resource = controller.resource_class
    instance_eval do
      menu :if => proc{ can?(:manage, Kernel.const_get(resource.to_s.classify)) }
    end
  end
end

CanCan::ControllerResource.class_eval do
  def collection_instance=(instance)
  end
  
  def resource_instance=(instance)
  end
end