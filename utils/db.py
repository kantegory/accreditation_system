from sqlalchemy import Column, String, Integer, Float
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker


Base = declarative_base()
engine = create_engine("sqlite:///accreditation.db")
session = sessionmaker(bind=engine)


class Users(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    token = Column(String)
    email = Column(String)


class Admin(Base):
    __tablename__ = "admin"
    id = Column(Integer, primary_key=True)
    login = Column(String)
    password = Column(String)


class GeneralizedWorkFunction(Base):
    __tablename__ = "generalizedworkfunction"
    id = Column(Integer, primary_key=True)
    codeOTF = Column(String)
    nameOTF = Column(String)
    levelOfQualification = Column(Integer)
    registrationNumber = Column(Integer)


class RequiredSkills(Base):
    __tablename__ = "requiredskills"
    id = Column(Integer, primary_key=True)
    codeTF = Column(String)
    registrationNumber = Column(Integer)
    requiredSkill = Column(String)


class LaborActions(Base):
    __tablename__ = "laboractions"
    id = Column(Integer, primary_key=True)
    codeTF = Column(String)
    registrationNumber = Column(Integer)
    laborAction = Column(String)


class NecessaryKnowledges(Base):
    __tablename__ = "necessaryknowledges"
    id = Column(Integer, primary_key=True)
    codeTF = Column(String)
    registrationNumber = Column(Integer)
    necessaryKnowledge = Column(String)


class Blanks(Base):
    __tablename__ = "blanks"
    id = Column(Integer, primary_key=True)
    name = Column(String)
    token = Column(String)
    state = Column(String)


class BlankStandards(Base):
    __tablename__ = "blankstandards"
    id = Column(Integer, primary_key=True)
    blankId = Column(Integer)
    standardRegistrationNumber = Column(Integer)


class UserAnswers(Base):
    __tablename__ = "useranswers"
    id = Column(Integer, primary_key=True)
    blankId = Column(Integer)
    userId = Column(Integer)
    question = Column(String)
    questionType = Column(String)
    answer = Column(String)
    registrationNumber = Column(Integer)


class Reports(Base):
    __tablename__ = "reports"
    id = Column(Integer, primary_key=True)
    blankId = Column(Integer)
    commonKoef = Column(Integer)


class Recommendations(Base):
    __tablename__ = "recommendations"
    id = Column(Integer, primary_key=True)
    report_id = Column(Integer)
    codeTF = Column(String)
    recommendation = Column(String)


class Competences(Base):
    __tablename__ = "competences"
    id = Column(Integer, primary_key=True)
    token = Column(String)
    competenceId = Column(Integer)
    competenceType = Column(String)


Base.metadata.create_all(bind=engine)
