{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01371') }},
        {{ ref('model_01028') }}
)
select id, 'model_01856' as name from sources
