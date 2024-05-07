# Function to convert duration to days
convert_duration_to_days() {
  duration=$1
  value=$(echo "$duration" | grep -o -E '[0-9]+')
  unit=$(echo "$duration" | grep -o -E '[a-zA-Z]+')
  case $unit in
    "ns") nanoseconds=$value ;;                     # Nanoseconds
    "us") nanoseconds=$((value * 1000)) ;;          # Microseconds to nanoseconds
    "ms") nanoseconds=$((value * 1000000)) ;;       # Milliseconds to nanoseconds
    "s")  nanoseconds=$((value * 1000000000)) ;;    # Seconds to nanoseconds
    "m")  nanoseconds=$((value * 60000000000)) ;;   # Minutes to nanoseconds
    "h")  nanoseconds=$((value * 3600000000000)) ;; # Hours to nanoseconds
    *) echo "Unknown unit: $unit" && return ;;
  esac
  days=$(echo "scale=2; $nanoseconds / 86400000000000" | bc)
  echo "$days"
}

# Function to generate keys based on algorithm
generate_key() {
  key_path=$1
  algorithm=$2
  size=$3

  case $algorithm in
    "RSA")
      openssl genrsa -out $key_path $size
      ;;
    "ECDSA")
      openssl ecparam -name prime256v1 -genkey -out $key_path
      ;;
    "Ed25519")
      openssl genpkey -algorithm Ed25519 -out $key_path
      ;;
    *)
      echo "Unsupported key algorithm: $algorithm" && exit 1
      ;;
  esac
}