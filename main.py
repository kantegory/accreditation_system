import requests
from bs4 import BeautifulSoup


def get_page(url):
    try:
        headers = {'user-agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0'}
        response = requests.get(url, headers=headers, verify=False)

        if response.ok:
            return response.text
        else:
            print("Error " + str(response.status_code))
            return False
    except requests.exceptions.ConnectTimeout:
        print('Oops. Connection timeout occured!')
    except requests.exceptions.ReadTimeout:
        print('Oops. Read timeout occured')
    except requests.exceptions.ConnectionError:
        print('Seems like dns lookup failed..')


def extract_standards(page):
    """ Extract standards from a given web page """
    standards = [page.findAll('input', {'class': 'button btn'})]
    return standards


def main():
    url = "https://profstandart.rosmintrud.ru/obshchiy-informatsionnyy-blok/" \
          "natsionalnyy-reestr-professionalnykh-standartov/reestr-professionalnykh-standartov/"

    response = get_page(url)
    page = BeautifulSoup(response, 'html5lib')
    standards = extract_standards(page)
    print(standards)


if __name__ == "__main__":
    main()
