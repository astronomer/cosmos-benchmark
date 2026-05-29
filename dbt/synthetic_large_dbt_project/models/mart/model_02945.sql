{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01754') }},
        {{ ref('model_02028') }}
)
select id, 'model_02945' as name from sources
