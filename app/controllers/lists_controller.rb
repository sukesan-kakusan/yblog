# frozen_string_literal: true

class ListsController < ApplicationController
  def create
    @list = List.new(list_params)
    if @list.save
      flash[:success] = 'リストを追加しました。'
    else
      flash[:danger] = '保存に失敗しました。'
    end
    redirect_back fallback_location: login_path
  end

  def show
    @list = List.find(params[:id])
    @articles = @list.articles.order(:rank)
  end

  def edit
    @list = List.find(params[:id])
    @articles = @list.articles
  end

  def update
    if List.update_with_rank(params[:id], params[:article_id_array])
      flash[:success] = 'リストを更新しました。'
    else
      flash[:danger] = '更新に失敗しました。'
    end
  end

  def destroy
    list = List.find(params[:id])
    user_id = list.user_id
    list.destroy
    flash[:success] = 'リストを削除しました。'
    redirect_to "/users/#{user_id}/lists"
  end

  private

  def list_params
    params.require(:list).permit(:name, :is_placed, :user_id)
  end
end
