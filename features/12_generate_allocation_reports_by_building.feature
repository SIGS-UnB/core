Feature: Generate allocation reports by building
  To use application resources
  As a system user
  I would like to generate a report by building

  Background:
    Given I am logged in as coordinator
    And click on link 'Relatórios'
    And click on link 'Prédios'

  Scenario: Generate report single building
    And click on link 'Icon pdf' in 'Pavilhão Anísio Teixeira'
    Then generate a PDF

  Scenario: Generate report single building with find
    And click on link 'Prédios'
    Then the 'Relatório por Prédios' page show some buildings
    And fill 'search' with 'Anísio'
    And click on button 'searchButton'
    Then the 'Relatório por Prédios' page show 'Pavilhão Anísio Teixeira'
    And click on link 'Icon pdf'
    Then generate a PDF

  Scenario: Generate report single building with empty find
    And click on link 'Prédios'
    Then the 'Relatório por Prédios' page show some buildings
    And fill 'search' with ''
    And click on button 'searchButton'
    Then the 'Relatório por Prédios' page show some buildings
    And click on link 'Icon pdf'
    Then generate a PDF

  Scenario: Generate report single building with nonexistents
    And click on link 'Prédios'
    Then the 'Relatório por Prédios' page show some buildings
    And fill 'search' with 'teste'
    And click on button 'searchButton'
    Then the 'Relatório por Prédios' page show 'Não há prédios registrados.'
