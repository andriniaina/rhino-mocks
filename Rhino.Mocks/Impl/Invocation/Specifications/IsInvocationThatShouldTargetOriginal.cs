using Castle.Core.Interceptor;
using andri.Mocks.Impl.InvocationSpecifications;
using andri.Mocks.Interfaces;

namespace andri.Mocks.Impl.Invocation.Specifications
{
    ///<summary>
    ///</summary>
    public class IsInvocationThatShouldTargetOriginal : ISpecification<IInvocation>
    {
        readonly IMockedObject proxyInstance;

        ///<summary>
        ///</summary>
        public IsInvocationThatShouldTargetOriginal(IMockedObject proxyInstance)
        {
            this.proxyInstance = proxyInstance;
        }

        ///<summary>
        ///</summary>
        public bool IsSatisfiedBy(IInvocation item)
        {
            return proxyInstance.ShouldCallOriginal(item.GetConcreteMethod());
        }
    }
}