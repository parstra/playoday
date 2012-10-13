require 'spec_helper'

describe TournamentsController do

  describe "GET index" do
    # TODO: change to factory girl
    let(:user){User.create({:email => 'someone@someone.com',
                         :password => 'foobar'})}
    let(:another_user){User.create({:email => 'someoneelse@someone.com',
                         :password => 'foobar'})}

    before do
      login_user(user)
    end

    let!(:my_tournament){
      #TODO: update this factory to have a name
      FactoryGirl.create(:tournament, :cup, {owner: user})
    }

    let!(:another_tournament){
      #TODO: update this factory to have a name
      FactoryGirl.create(:tournament, :cup, {owner: another_user})
    }

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end

    context "user owns a tournament" do
      it "fetches tournaments that the user owns" do
        get :index
        assigns(:my_tournaments).should == [my_tournament]
      end
    end

    context "user participates in tournaments" do

      before do
        another_tournament.users << user
      end

      it "fetches participating tournaments" do
        get :index
        assigns(:other_tournaments).should == [another_tournament]
      end
    end

  end

end
