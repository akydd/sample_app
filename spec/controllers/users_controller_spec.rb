require 'spec_helper'

describe UsersController do

  describe "delete" do
    describe "as an admin user" do
      # use 'let!' here so that users exist before tests are run, and changes
      # to db are counted correctly.
      let!(:admin_1) { FactoryGirl.create(:admin) }
      let!(:admin_2) { FactoryGirl.create(:admin) }
      let!(:user) { FactoryGirl.create(:user) }

      before(:each) do
        sign_in admin_1
      end

      it "cannot delete self" do
        expect { delete :destroy, id: admin_1.id }.not_to change(User, :count)
      end

      it "can delete non-admin user" do
        expect { delete :destroy, id: user.id }.to change(User, :count).by(-1)
      end

      it "can delete other admin users" do
        expect { delete :destroy, id: admin_2.id }.to change(User, :count).by(-1)
      end

    end
  end
end
