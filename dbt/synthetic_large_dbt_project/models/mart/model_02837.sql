{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02074') }},
        {{ ref('model_02243') }}
)
select id, 'model_02837' as name from sources
