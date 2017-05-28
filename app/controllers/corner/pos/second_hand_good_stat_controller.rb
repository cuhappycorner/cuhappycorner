require 'csv'

class Corner::Pos::SecondHandGoodStatController < ApplicationController
  before_action :authenticate_user!

  # GET
  def index
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
  end

  # POST
  def show
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @second_hand_transaction = nil
    @date = nil
    @end_date
    if params[:type] == 'all'
      @second_hand_transaction = Corner::Account::ProductSubTransaction.all
    elsif params[:type] == 'month'
      @date = Time.zone.local(params[:s_year], params[:s_month], 1, 0, 0, 0)
      @end_date = @date.next_month
      @second_hand_transaction = Corner::Account::ProductSubTransaction.where('$and' => [{:created_at => {:$gte => @date}}, {:created_at => {:$lte => @end_date}}])
    elsif params[:type] == 'date'
      date = Time.zone.local(params[:s_year], params[:s_month], params[:s_day], 0, 0, 0)
      end_date = @date.tomorrow
      @second_hand_transaction = Corner::Account::ProductSubTransaction.where('$and' => [{:created_at => {:$gte => @date}}, {:created_at => {:$lte => @end_date}}])
    elsif params[:type] == 'period'
      @date = Time.zone.local(params[:s_year], params[:s_month], params[:s_day], 0, 0, 0)
      @end_date = Time.zone.local(params[:e_year], params[:e_month], params[:e_day], 0, 0, 0).tomorrow
      @second_hand_transaction = Corner::Account::ProductSubTransaction.where('$and' => [{:created_at => {:$gte => @date}}, {:created_at => {:$lte => @end_date}}])
    end
  end

  def export_data
    unless current_user.role.include? Role.find_by(name: 'shopkeeper')
      flash[:alert] = t('error.notauthorized')
      redirect_to(request.referrer || root_path) and return
    end
    @second_hand_transaction = nil
    @date = nil
    @end_date
    if params[:type] == 'all'
      @second_hand_transaction = Corner::Account::ProductSubTransaction.all
    elsif params[:type] == 'month'
      @date = Time.zone.local(params[:s_year], params[:s_month], 1, 0, 0, 0)
      @end_date = @date.next_month
      @second_hand_transaction = Corner::Account::ProductSubTransaction.where('$and' => [{:created_at => {:$gte => @date}}, {:created_at => {:$lte => @end_date}}])
    elsif params[:type] == 'date'
      date = Time.zone.local(params[:s_year], params[:s_month], params[:s_day], 0, 0, 0)
      end_date = @date.tomorrow
      @second_hand_transaction = Corner::Account::ProductSubTransaction.where('$and' => [{:created_at => {:$gte => @date}}, {:created_at => {:$lte => @end_date}}])
    elsif params[:type] == 'period'
      @date = Time.zone.local(params[:s_year], params[:s_month], params[:s_day], 0, 0, 0)
      @end_date = Time.zone.local(params[:e_year], params[:e_month], params[:e_day], 0, 0, 0).tomorrow
      @second_hand_transaction = Corner::Account::ProductSubTransaction.where('$and' => [{:created_at => {:$gte => @date}}, {:created_at => {:$lte => @end_date}}])
    end

    head = 'EF BB BF'.split(' ').map{|a|a.hex.chr}.join()
    header = ['Code', 'Category', 'Good', 'In', 'Out']
    file  = CSV.generate(csv = head) do |csv|
      csv << header
      Corner::Pos::SecondHandGoodCategory.all.order_by(:order => 'asc').each do |category|
        category.item.all.order_by(:order => 'asc').each do |good|
          csv << [(category.order + 64).chr.to_s + ("%.2d" % good.order ), category.name, good.name, @second_hand_transaction.where(product: good).where(flow_type: "debit").sum(:quantity), @second_hand_transaction.where(product: good).where(flow_type: "credit").sum(:quantity)]
        end
      end
    end
    send_data file, filename: "SecondHandGood-Statistics-#{Time.now.strftime("%y%m%d%H%M%S")}.csv", type: "text/csv"
  end
end