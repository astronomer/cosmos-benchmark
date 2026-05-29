{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00882') }},
        {{ ref('model_01471') }}
)
select id, 'model_01554' as name from sources
