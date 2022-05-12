module AdminPanel
  class CollegesController < BaseController
    before_action :set_college, only: %i[edit update destroy]

    def index
      @colleges = College.latest.includes(:college_domains)
      @colleges = FilterCollegeQuery.new(@colleges).call(params)
      @colleges = @colleges.page(page).per(per_page)
    end

    def new
      @college = College.new
    end

    def create
      @college = College.new college_params

      flash[:notice] = 'College is successfully created.' if @college.save
    end

    def edit; end

    def update
      flash[:notice] = 'College is successfully updated.' if @college.update(college_params)
    end

    def destroy
      if @college.destroy
        flash[:notice] = 'This College destroyed successfully'
      else
        flash[:alert] = @college.errors.full_messages.to_sentence
      end

      redirect_to admin_panel_colleges_path
    end

    private

    def set_college
      @college = College.find(params[:id])
    end

    def college_params
      params.require(:college).permit(:name, college_domains_attributes: [:id, :domain, :_destroy])
    end
  end
end
