{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01105') }},
        {{ ref('model_01245') }}
)
select id, 'model_01977' as name from sources
