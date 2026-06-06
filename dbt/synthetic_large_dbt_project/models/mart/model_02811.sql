{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02180') }},
        {{ ref('model_01666') }}
)
select id, 'model_02811' as name from sources
