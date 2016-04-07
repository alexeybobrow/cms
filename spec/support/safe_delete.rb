shared_examples_for 'safe deleting model' do
  describe '.actual' do
    let!(:model) { create model_factory }
    let!(:deleted_model) { create model_factory, deleted_at: 1.hour.ago }

    it 'can show only actual models' do
      expect(model_class.actual).to match_array([model])
      expect(model_class.actual(nil)).to match_array([model])
      expect(model_class.actual(:actual)).to match_array([model])
      expect(model_class.actual('actual')).to match_array([model])
    end

    it 'can show only deleted models' do
      expect(model_class.actual(:deleted)).to match_array([deleted_model])
      expect(model_class.actual('deleted')).to match_array([deleted_model])
    end

    it 'can show all models' do
      expect(model_class.actual(:all)).to match_array([model, deleted_model])
      expect(model_class.actual('all')).to match_array([model, deleted_model])
    end
  end

  describe '#safe_delete' do
    let!(:model) { create model_factory }

    it 'marks model as deleted' do
      model.safe_delete
      expect(model).to be_deleted
    end
  end

  describe '#deleted?' do
    let!(:model) { create model_factory }

    it 'is false for a regular model' do
      expect(model).not_to be_deleted
    end

    it 'is true for a deleted model' do
      model.deleted_at = Time.current
      expect(model).to be_deleted
    end
  end
end
