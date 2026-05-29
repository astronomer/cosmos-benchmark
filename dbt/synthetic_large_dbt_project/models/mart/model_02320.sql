{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01793') }},
        {{ ref('model_01960') }}
)
select id, 'model_02320' as name from sources
