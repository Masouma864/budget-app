class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[edit update destroy]
  before_action :set_group, only: %i[index new edit create update destroy]
  before_action :set_author, only: %i[index edit create update destroy]

  # GET /expenses or /expenses.json
  def index
    @expenses = @group.expenses.order(created_at: :desc)
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

   # GET group/expenses/1/edit
  # Get an existing expense record to render the edit form
  def edit; end

  # POST /expenses or /expenses.json
  def create
    @expense = Expense.new(author: @author, **expense_params)
    if @expense.save
      @group_expense = GroupExpense.create(group: @group, expense: @expense)
      redirect_to group_expenses_url(@group), notice: 'Expense was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    if @expense.update(expense_params)
      redirect_to group_expenses_url, notice: 'Expense was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense.destroy

    redirect_to group_expenses_url(@group), notice: 'Expense was successfully destroyed.'
  end

  private
  def set_user
    @author = current_user
  end

  def set_group
    @group = set_user.groups.find(params[:group_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_expense
    @expense = set_user.expenses.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def expense_params
    params.require(:expense).permit(:name, :amount)
  end
end
