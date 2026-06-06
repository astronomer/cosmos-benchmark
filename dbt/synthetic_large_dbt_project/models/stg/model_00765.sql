{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00590') }},
        {{ ref('model_00642') }},
        {{ ref('model_00078') }}
)
select id, 'model_00765' as name from sources
