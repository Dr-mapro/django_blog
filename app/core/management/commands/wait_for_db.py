"""
Django command to wait for the database to be available
"""
import time

from psycopg2 import OperationalError as Psycopg2OpError

from django.core.management.base import BaseCommand
from django.db.utils import OperationalError
from django.db import connection


class Command(BaseCommand):
    """Django command to wait for database"""

    def handle(self, *args, **options):
        """Entrypoint for database when getting OperationalError"""
        self.stdout.write('waiting for database...')
        db_up = False
        while db_up is False:
            try:
                self.check(database=['default'])
                #connection.ensure_connection()
                db_up = True
            except (Psycopg2OpError, OperationalError):
                self.stdout.write('Database unavailable, waiting 1 second...')
                time.sleep(1)