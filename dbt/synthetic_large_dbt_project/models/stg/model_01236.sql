{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00363') }},
        {{ ref('model_00231') }}
)
select id, 'model_01236' as name from sources
