import csv


def read_csv(filepath):
    """
    This function reads the example dataset from a CSV file and returns a
    list of lists.
    """
    data = []

    with open(filepath) as fd:
        reader = csv.reader(fd, delimiter=',')

        for row in reader:
            row = [int(row[0]), row[1], row[2], int(row[3]), row[4],
                   row[5], row[6], row[7], row[8], int(row[9]),
                   int(row[10]), int(row[11]), row[12], row[13]]
            data.append(list(map(lambda x: x.strip() if isinstance(x, str) else x, row)))

    return data
