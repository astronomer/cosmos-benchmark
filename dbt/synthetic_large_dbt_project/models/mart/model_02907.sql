{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01963') }},
        {{ ref('model_02069') }}
)
select id, 'model_02907' as name from sources
