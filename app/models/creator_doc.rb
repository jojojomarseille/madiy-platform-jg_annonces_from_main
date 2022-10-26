class CreatorDoc < ApplicationRecord
  belongs_to :creator, inverse_of: :creator_docs
  has_one_attached :document

  enum document_type: {
    id: "Piéce d'identitée",
    iban: "IBAN",
    registery_individual: "Preuve d'enregistrement auto-entreprise",
    registery_company: "Preuve d'enregistrement société",
    statut: "Statuts",
    effectiv_beneficiary: "Bénéficiaires effectifs",
    cgu: "CGU-CGV"
  }, _suffix: true

  enum statut: {
    soumis: "soumis",
    validé: "validé",
    rejeté: "rejeté"
  }, _suffix: true

 
end
