{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02038') }},
        {{ ref('model_01977') }}
)
select id, 'model_02961' as name from sources
