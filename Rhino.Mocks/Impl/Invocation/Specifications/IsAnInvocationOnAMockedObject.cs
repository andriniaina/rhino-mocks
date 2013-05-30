using Castle.Core.Interceptor;
using andri.Mocks.Impl.InvocationSpecifications;
using andri.Mocks.Interfaces;

namespace andri.Mocks.Impl.Invocation.Specifications
{
    ///<summary>
    ///</summary>
    public class IsAnInvocationOnAMockedObject : ISpecification<IInvocation>
    {
        ///<summary>
        ///</summary>
        public bool IsSatisfiedBy(IInvocation invocation)
        {
            return invocation.Method.DeclaringType == typeof (IMockedObject);
        }
    }
}