postgres:
	docker run --name postgres16 -p 6432:5432 -e POSTGRES_PASSWORD=123456 -d postgres

createdb:
	docker exec -it postgres16 createdb -U postgres simple_bank

dropdb:
	revoke_public
	docker exec -it postgres16 dropdb -U postgres simple_bank

revoke_public:
	terminate_pg_backend
	docker exec -it postgres16 psql -U postgres -d simple_bank -c "REVOKE ALL ON DATABASE simple_bank FROM PUBLIC;"

terminate_pg_backend:
	docker exec -it postgres16 psql -U postgres -d simple_bank -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = current_database() AND pid <> pg_backend_pid();"

migrateup:
	migrate -path db/migration -database "postgresql://postgres:123456@localhost:6432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://postgres:123456@localhost:6432/simple_bank?sslmode=disable" -verbose down

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb revoke_public terminate_pg_backend test

