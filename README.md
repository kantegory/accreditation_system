# accreditation_system
ITMO Practice 2020

1. Clone/download project
```bash
git clone https://github.com/kantegory/accreditation_system.git
```

2. Install requirments
```bash
pip3 install -r requirments.txt
```

3. Launch main.py
```bash
python3 main.py
```

Now accreditation system is avaliable on http://hostname:8080/

Admin-panel: http://hostname:8080/admin  
You can configure login and password for admin-panel in main.py (def check()).  
Quiz for graduates: http://hostname:8080/quiz/<token>/<id>
