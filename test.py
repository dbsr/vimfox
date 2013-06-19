if __name__ == '__main__':
    import argparse
    import json
    parser = argparse.ArgumentParser()

    parser.add_argument('json', type=str)

    args = vars(parser.parse_args())

    a = json.loads('"' + args['json'] + '"')

    print type(a)
