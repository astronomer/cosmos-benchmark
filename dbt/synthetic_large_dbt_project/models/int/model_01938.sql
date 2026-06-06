{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01179') }},
        {{ ref('model_01287') }}
)
select id, 'model_01938' as name from sources
