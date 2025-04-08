from flask import Blueprint, render_template, request, redirect, url_for, flash
from .models import User
from .db import db

auth_bp = Blueprint('auth_bp', __name__, template_folder='templates')

@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form.get('username')
        email = request.form.get('email')
        password = request.form.get('password')

        # Check if user already exists
        existing_user = User.query.filter_by(email=email).first()
        if existing_user:
            flash("User with this email already exists!", "error")
            return redirect(url_for('auth_bp.register'))

        new_user = User(username, email, password)
        new_user.save()
        flash("Registration successful! Please log in.", "success")
        return redirect(url_for('auth_bp.login'))

    return render_template('register.html')

@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')

        user = User.query.filter_by(email=email).first()
        if not user or not user.check_password(password):
            flash("Invalid credentials!", "error")
            return redirect(url_for('auth_bp.login'))

        user.last_login = db.func.now()
        user.save()

        # For a real app, you’d use Flask-Login or a session
        flash("Logged in successfully!", "success")
        return redirect(url_for('main.dashboard'))

    return render_template('login.html')
