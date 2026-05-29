{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01977') }},
        {{ ref('model_02229') }}
)
select id, 'model_02773' as name from sources
