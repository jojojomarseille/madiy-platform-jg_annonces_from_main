class Creator < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :trackable

  has_many :workshops
  has_many :creator_docs, inverse_of: :creator, :dependent => :destroy
  
  has_one_attached :picture

  accepts_nested_attributes_for :creator_docs, allow_destroy: true

  validates :first_name, :last_name, :phone_number, presence: true
  validate :password_complexity
 
  enum legal_statut: {
    individual: "Auto-entrepreneur",
    société: "Société"
  }, _suffix: true


  scope :creators, -> {Creator.all}

  def creators_docs
    return CreatorDocs.where(creator_id: self.id)
  end

  def docs_list
    if self.legal_statut == "société"
      return [:id, :iban, :registery_company, :statut, :effectiv_beneficiary]
    else
      return [:id, :iban, :registery_individual]
    end
  end
  
  def doc_url(a)
    return self.creator_docs.where(document_type: "#{a}", statut: "validé").last.document
  end

  def cgu_doc
    return self.creator_docs.where(document_type: "cgu", statut: "validé").last.document
  end

  def password_complexity
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/
    errors.add :password, "n'est pas suffisamment sûr. Pour être valide, il doit comporter au moins une majuscule, une minuscule, un chiffre et un caractère spécial"
  end

end
