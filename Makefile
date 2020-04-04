init:
	pip3 install -r requirements.txt

config:
	cp utils/config.py.example utils/config.py && nano utils/config.py

service:
	curl -s https://raw.githubusercontent.com/Etersoft/eepm/master/packed/epm.sh | bash /dev/stdin ei --auto && \
	sudo cp accreditation.service /lib/systemd/system/ && \
	sudo cp -r ../accreditation_system /usr/bin/ && \
	serv accreditation on && serv accreditation start && \
	echo "service started use 'serv status accreditation' for check status of it"
