class ResourceController < ApplicationController
  def destroy_resource(resource, redirect_url)
    resource.destroy

    respond_to do |format|
      format.html { redirect_to(redirect_url) }
      format.xml  { head :ok }
    end
  end

  def update_resource(resource)
    class_name = resource.class.to_s

    respond_to do |format|
      if resource.update_attributes(params[class_name.underscore.to_sym])
        format.html { redirect_to(resource, :notice => "#{class_name.titleize} was successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => resource.errors, :status => :unprocessable_entity }
      end
    end
  end
end
