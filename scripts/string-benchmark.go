package test
 
import (
    "bytes"
    "fmt"
    "strings"
    "testing"
)
 
var (
    s1 = "local"
    b1 = []byte("local")
)
 
const LIMIT = 1000
 
func BenchmarkStringSprintf(b *testing.B) {
    var q string
    for i := 0; i < b.N; i++ {
        for j := 0; j < LIMIT; j++ {
            q = fmt.Sprintf("%s%s", q, s1)
        }
        q = ""
    }
    b.ReportAllocs()
}
 
func BenchmarkStringJoin(b *testing.B) {
    var q string
    for i := 0; i < b.N; i++ {
        for j := 0; j < LIMIT; j++ {
            q = strings.Join([]string{q, s1}, "")
        }
        q = ""
    }
    b.ReportAllocs()
}
 
func BenchmarkStringAdd(b *testing.B) {
    var q string
    for i := 0; i < b.N; i++ {
        for j := 0; j < LIMIT; j++ {
            q = q + s1
        }
        q = ""
    }
    b.ReportAllocs()
}
 
func BenchmarkStringWrite(b *testing.B) {
    q := new(bytes.Buffer)
    for i := 0; i < b.N; i++ {
        for j := 0; j < LIMIT; j++ {
            q.WriteString(s1)
        }
        q = new(bytes.Buffer)
    }
}
 
func BenchmarkStringAppend(b *testing.B) {
    var q []byte
    for i := 0; i < b.N; i++ {
        for j := 0; j < LIMIT; j++ {
            q = append(q, s1...)
        }
        q = nil
    }
    b.ReportAllocs()
}
 
func BenchmarkBytesJoin(b *testing.B) {
    var q []byte
    for i := 0; i < b.N; i++ {
        for j := 0; j < LIMIT; j++ {
            q = bytes.Join([][]byte{q, b1}, nil)
        }
        q = nil
    }
    b.ReportAllocs()
}
 
func BenchmarkBytesAppend(b *testing.B) {
    var q []byte
    for i := 0; i < b.N; i++ {
        for j := 0; j < LIMIT; j++ {
            q = append(q, b1...)
        }
        q = nil
    }
    b.ReportAllocs()
}
 
func BenchmarkBytesWrite(b *testing.B) {
    q := new(bytes.Buffer)
    for i := 0; i < b.N; i++ {
        for j := 0; j < LIMIT; j++ {
            q.Write(b1)
        }
        q = new(bytes.Buffer)
    }
}
