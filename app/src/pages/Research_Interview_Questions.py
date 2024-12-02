import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_jobs_card"):
    ui.element("h2", children=["Practice Interview Questions"], className="text-2xl font-bold text-gray-800", key="view_jobs_title")
    ui.element("div", children=["\n\n"], key="view_jobs_divider")
    ui.element("p", children=["Check out interview questions from past applicants who have graciously submitted their experiences to help you prepare for your next interview."], className="text-gray-600")

data = {} 
try:
    data = requests.get('http://api:4000/i/interview_questions').json()
except:
    logger.error("Error retrieving data from the API")
    data = []  

def InterviewQuestionCard(question):
    with ui.element("div", key=f"interview_question_{question['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
        ui.element("h3", children=[question["question"]], className="text-xl font-bold text-gray-600", key=f"interview_question{question['id']}")
        

if data and isinstance(data, list):
        for job in data:
            InterviewQuestionCard(job)
    
else:
    ui.element("h3", children=["No interview questions found"], className="text-xl font-bold text-gray-600")
