import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_student_card"):
    ui.element("h2", children=["Manage Students"], className="text-2xl font-bold text-gray-800", key="view_apps_title")
    ui.element("div", children=["\n\n"], key="view_student_profiles_divider")
    ui.element("p", children=["View, add, update, and delete student profiles."], className="text-gray-600")

data = {} 
try:
    data = requests.get('http://api:4000/s/students').json()
except:
    logger.error("Error retrieving data from the API")
    data = []  
    
def deleteStudent(student):
    try:
        response = requests.delete(f'http://api:4000/s/students/{student["id"]}')
        if response.status_code == 200:
            logger.info(f"Student deleted {student['id']}")    
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to delete student: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key=f"delete_student_error_{student['id']}"
            )
    except:
        logger.error("Error deleting student")
        ui.element(
            "p",
            children=[
                f"Failed to delete student: Unknown error"
            ],
            className="text-red-500",
            key=f"delete_student_error_{student['id']}"
        )
    

def StudentProfileCard(student):
    with ui.element("div", key=f"student_card_{student['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
        ui.element(
            "h3",
            children=[f"Name: {student['name']}"],
            className="text-xl font-bold text-gray-800",
            key=f"student_profiles_{student['id']}"
        )

        ui.element(
            "p",
            children=[f"Email: {student['email']}"],
            className="text-gray-600",
            key=f"student_profiles_{student['id']}"
        )

        ui.element(
            "p",
            children=[f"GPA: {student['gpa']}"],
            className="text-gray-600",
            key=f"student_profiles_{student['id']}"
        )

        ui.element(
            "p",
            children=[f"Email: {student['email']}"],
            className="text-gray-600",
            key=f"student_profiles_{student['id']}"
        )

        ui.element(
            "p",
            children=[f"Major: {student['major_name']}"],
            className="text-gray-600",
            key=f"student_profiles_{student['id']}"
        )

        ui.element(
            "p",
            children=[f"Grad Year: {student['grad_year']}"],
            className="text-gray-600",
            key=f"student_profiles_{student['id']}"
        )

        ui.element(
            "p",
            children=[f"Advised By: {student['advisor_name']}"],
            className="text-gray-400 text-sm",
            key=f"student_profiles_{student['id']}"
        )
        
        deleteBtn = ui.button("Delete", className="bg-red-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"delete_student_{student['id']}")
        if deleteBtn:
            deleteStudent(student)
        ui.alert_dialog(show=deleteBtn, title="Deleted Student", description=f"The student profile under the name {student['name']} has been deleted.", confirm_label="OK", cancel_label="Cancel", key=f"alert_dialog_{application['id']}")




if data and isinstance(data, list):
    if data:
        for application in data:
            ApplicationCard(application)
    else:
        ui.element("h3", children=["No applications sent out."], className="text-xl font-bold text-gray-800")
else:
    ui.element("h3", children=["No applications sent out."], className="text-xl font-bold text-gray-800")
